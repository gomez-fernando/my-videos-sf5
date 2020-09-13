<?php

namespace App\Controller;

use App\Entity\Comment;
use App\Entity\Video;
use App\Repository\VideoRepository;
use App\Utils\CategoryTreeFrontPage;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use App\Entity\Category;
use Symfony\Component\Security\Core\Authentication\Token\UsernamePasswordToken;
use Symfony\Component\Security\Core\Encoder\UserPasswordEncoderInterface;
use Symfony\Component\Security\Http\Authentication\AuthenticationUtils;
use App\Entity\User;
use App\Form\UserType;

class FrontController extends AbstractController
{
    /**
     * @Route("/", name="main_page")
     */
    public function index()
    {
        return $this->render('front/index.html.twig');
    }

    /**
     * @Route("/video-list/category/{categoryname},{id}", name="video_list")
     * @param $id
     * @param CategoryTreeFrontPage $categories
     * @param Request $request
     * @return Response
     */
    public function videoList($id, CategoryTreeFrontPage $categories, Request $request)
    {
        $categories->getCategoryListAndParent($id);
        $ids = $categories->getChildIds($id);
        array_push($ids, $id);
//        dump($categories);
        $videos = $this->getDoctrine()->getRepository(Video::class)->findByChildIds($ids, $request->get('sortby'));
        return $this->render('front/video_list.html.twig', [
            'subcategories' => $categories,
            'videos' => $videos
        ]);
    }

    /**
     * @Route("/video-details/{video}", name="video_details")
     * @param $video
     * @param VideoRepository $repo
     * @return Response
     */
    public function videoDetails(Video $video, VideoRepository $repo)
    {
//        dump($repo->videoDetails($video));
        return $this->render('front/video_details.html.twig', [
            'video' => $repo->videoDetails($video)
        ]);
    }

    /**
     * @Route("/search-results", name="search_results", methods={"GET"})
     */
    public function searchResults(Request $request)
    {
        $videos = null;
        $query = null;

        if($query = $request->get('query'))
        {
            $videos = $this->getDoctrine()->getRepository(Video::class)->findByTitle($query, $request->get('sortby'));

//            if(!$videos->getItems()) $videos = null;
        }

        return $this->render('front/search_results.html.twig', [
            'videos' => $videos,
            'query' => $query
        ]);
    }

    /**
     * @Route("/pricing", name="pricing")
     */
    public function pricing()
    {
        return $this->render('front/pricing.html.twig');
    }

    /**
     * @Route("/register", name="register")
     * @param Request $request
     * @param UserPasswordEncoderInterface $password_encoder
     * @return Response
     */
    public function register(Request $request, UserPasswordEncoderInterface $password_encoder)
    {
        $user = new User();
        $form = $this->createForm(UserType::class, $user);
        $form->handleRequest($request);
        if($form->isSubmitted() && $form->isValid())
        {
            $entityManager = $this->getDoctrine()->getManager();
            $user->setName($request->request->get('user')['name']);
            $user->setLastName($request->request->get('user')['last_name']);
            $user->setEmail($request->request->get('user')['email']);

            $password = $password_encoder->encodePassword($user, $request->request->get('user')['password']['first']);
            $user->setPassword($password);

            $entityManager->persist($user);
            $entityManager->flush();

            $this->loginUserAutomatically($user, $password);

            return $this->redirectToRoute('admin_main_page');
        }

        return $this->render('front/register.html.twig', [
            'form' => $form->createView()
        ]);
    }

    /**
     * @Route("/login", name="login")
     * @param AuthenticationUtils $helper
     * @return Response
     */
    public function login(AuthenticationUtils $helper)
    {
        return $this->render('front/login.html.twig', [
            'error' => $helper->getLastAuthenticationError()
        ]);
    }

    public function loginUserAutomatically($user, $password)
    {
        $token = new UsernamePasswordToken(
            $user,
            $password,
            'main',
            $user->getRoles()
        );
        $this->get('security.token_storage')->setToken($token);
        $this->get('session')->set('_security_main', serialize($token));
    }

    /**
     * @Route("/logout", name="logout")
     * @return void
     * @throws \Exception
     */
    public function logout(): void
    {
        throw new \Exception('This should never be reached!');
    }

    /**
     * @Route("/payment", name="payment")
     */
    public function payment()
    {
        return $this->render('front/payment.html.twig');
    }

    /**
     * @Route("/new-comment/{video}", methods={"POST"}, name="new_comment")
     * @param Video $video
     * @param Request $request
     */
    public function newComment(Video $video, Request $request)
    {
        $this->denyAccessUnlessGranted('IS_AUTHENTICATED_REMEMBERED');
        if(!empty(trim($request->request->get('comment'))))
        {
            $comment = new Comment();
            $comment->setContent($request->request->get('comment'));
            $comment->setUser($this->getUser());
            $comment->setVideo($video);

            $em = $this->getDoctrine()->getManager();
            $em->persist($comment);
            $em->flush();
        }

        return $this->redirectToRoute('video_details', [
            'video' => $video->getId()
        ]);
    }

    /**
     * @Route("video-list/{video}/like", name="like_video", methods={"POST"})
     * @Route("video-list/{video}/dislike", name="dislike_video", methods={"POST"})
     * @Route("video-list/{video}/unlike", name="undo_like_video", methods={"POST"})
     * @Route("video-list/{video}/undodislike", name="undo_dislike_video", methods={"POST"})
     */
    public function toggleLikesAjax(Video $video, Request $request)
    {
        $this->denyAccessUnlessGranted('IS_AUTHENTICATED_REMEMBERED');

        switch ($request->get('_route'))
        {
            case 'like_video':
                $result = $this->likeVideo($video);
                break;
            case 'dislike_video':
                $result = $this->dislikeVideo($video);
                break;
            case 'undo_like_video':
                $result = $this->undoLikeVideo($video);
                break;
            case 'undo_dislike_video':
                $result = $this->undoDislikeVideo($video);
                break;
        }
        return $this->json(['action' => $result, 'id' => $video->getId()]);
    }

    public function likeVideo($video)
    {
        $user = $this->getUser();
        $user->addLikedVideo($video);
        $em =$this->getDoctrine()->getManager();

        $em->persist($user);
        $em->flush();

        return 'liked';
    }

    public function dislikeVideo($video)
    {
        $user = $this->getUser();
        $user->addDislikedVideo($video);
        $em =$this->getDoctrine()->getManager();

        $em->persist($user);
        $em->flush();

        return 'disliked';
    }

    public function undoLikeVideo($video)
    {
        $user = $this->getUser();
        $user->removeLikedVideo($video);
        $em =$this->getDoctrine()->getManager();

        $em->persist($user);
        $em->flush();

        return 'undo liked';
    }

    public function undoDislikeVideo($video)
    {
        $user = $this->getUser();
        $user->removeDislikedVideo($video);
        $em =$this->getDoctrine()->getManager();

        $em->persist($user);
        $em->flush();

        return 'undo disliked';
    }

    public function mainCategories()
    {
        $categories = $this->getDoctrine()
            ->getRepository(Category::class)
            ->findBy(['parent' => null], ['name' => 'ASC']);
        return $this->render('front/_main_categories.html.twig', [
            'categories' => $categories
        ]);
    }
}
