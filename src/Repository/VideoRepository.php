<?php

namespace App\Repository;

use App\Entity\Video;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
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
        $sort_method = $sort_method != 'rating' ? $sort_method : 'ASC';
        $dbquery = $this->createQueryBuilder('v')
            ->andWhere('v.category IN (:val)')
            ->setParameter('val', $value)
            ->orderBy('v.title', $sort_method)
            ->getQuery();
        return $dbquery->getResult();
    }

    public function findByTitle(string $query, ?string $sort_method)
    {
        $sort_method = $sort_method != 'rating' ? $sort_method : 'ASC';

        $queryBuilder = $this->createQueryBuilder('v');
        $searchTerms = $this->prepareQuery($query);

        foreach ($searchTerms as $key => $term)
        {
            $queryBuilder
                ->orWhere('v.title LIKE :t_'.$key)
                ->setParameter('t_'.$key, '%'.trim($term).'%');
        }

        $dbquery = $queryBuilder
            ->orderBy('v.title', $sort_method)
            ->getQuery();

        return $dbquery->getResult();
    }

    private function prepareQuery(string $query): array
    {
        return explode(' ', $query);
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
