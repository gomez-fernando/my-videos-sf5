<?php

namespace App\Repository;

use App\Entity\Video;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\ORM\NonUniqueResultException;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @method Video|null find($id, $lockMode = null, $lockVersion = null)
 * @method Video|null findOneBy(array $criteria, array $orderBy = null)
 * @method Video[]    findAll()
 * @method Video[]    findBy(array $criteria, array $orderBy = null, $limit = null, $offset = null)
 */
class VideoRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Video::class);
    }

    public function findByChildIds(array $value, ?string $sort_method)
    {
        if($sort_method != 'rating')
        {
            $dbquery = $this->createQueryBuilder('v')
                ->andWhere('v.category IN (:val)')
                ->leftJoin('v.comments', 'c')
//                ->addSelect('c')
                ->leftJoin('v.usersThatLike', 'l')
                ->leftJoin('v.usersThatDontLike', 'd')
                ->addSelect('c', 'l', 'd')
                ->setParameter('val', $value)
                ->orderBy('v.title', $sort_method)
                ->getQuery();
        }
        else
        {
            $dbquery = $this->createQueryBuilder('v')
                ->addSelect('COUNT(l) AS HIDDEN likes')
                ->leftJoin('v.usersThatLike', 'l')
                ->andWhere('v.category IN (:val)')
                ->setParameter('val', $value)
                ->groupBy('v')
                ->orderBy('likes', 'DESC')
                ->getQuery();
        }

        return $dbquery->getResult();
    }

    public function findByTitle(string $query, ?string $sort_method)
    {
        $queryBuilder = $this->createQueryBuilder('v');
        $searchTerms = $this->prepareQuery($query);

        foreach ($searchTerms as $key => $term)
        {
            $queryBuilder
                ->orWhere('v.title LIKE :t_'.$key)
                ->setParameter('t_'.$key, '%'.trim($term).'%');
        }

        if($sort_method != 'rating')
        {
            $dbquery = $queryBuilder
                ->orderBy('v.title', $sort_method)
                ->leftJoin('v.comments', 'c')
                ->leftJoin('v.usersThatLike', 'l')
                ->leftJoin('v.usersThatDontLike', 'd')
                ->addSelect('c', 'l', 'd')
                ->getQuery();
        }
        else
        {
            $dbquery = $queryBuilder
                ->addSelect('COUNT(l) AS HIDDEN likes', 'c')
                ->leftJoin('v.usersThatLike', 'l')
                ->leftJoin('v.comments', 'c')
                ->groupBy('v', 'c')
                ->orderBy('likes', 'DESC')
                ->getQuery();
        }



        return $dbquery->getResult();
    }

    private function prepareQuery(string $query): array
    {
        $terms = array_unique(explode(' ', $query));
        return array_filter($terms, function ($term){
            return 2 <= mb_strlen($term);
        });
    }

    public function videoDetails($id)
    {
        try {
            return $this->createQueryBuilder('v')
                ->leftJoin('v.comments', 'c')
                ->leftJoin('c.user', 'u')
                ->addSelect('c', 'u')
                ->where('v.id = :id')
                ->setParameter('id', $id)
                ->getQuery()
                ->getOneOrNullResult();
        } catch (NonUniqueResultException $e) {
            return new \Exception('fail');
        }
    }

    // /**
    //  * @return Video[] Returns an array of Video objects
    //  */
    /*
    public function findByExampleField($value)
    {
        return $this->createQueryBuilder('v')
            ->andWhere('v.exampleField = :val')
            ->setParameter('val', $value)
            ->orderBy('v.id', 'ASC')
            ->setMaxResults(10)
            ->getQuery()
            ->getResult()
        ;
    }
    */

    /*
    public function findOneBySomeField($value): ?Video
    {
        return $this->createQueryBuilder('v')
            ->andWhere('v.exampleField = :val')
            ->setParameter('val', $value)
            ->getQuery()
            ->getOneOrNullResult()
        ;
    }
    */
}
