<?php

namespace App\DataFixtures;

use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Persistence\ObjectManager;
use Symfony\Component\Security\Core\User;
use App\Entity\Subscription;

class SubscriptionFixtures extends Fixture
{
    public function load(ObjectManager $manager)
    {
        foreach ($this->getSubscriptionData() as [
            $user_id, $plan, $valid_to, $payment_status, $free_plan_used
        ])
        {
            $subscription = new Subscription();
            $subscription->setPlan($plan);
            $subscription->setValidTo($valid_to);
            $subscription->setPaymentStatus($payment_status);
            $subscription->setFreePlanUsed($free_plan_used);

            $user = $manager->getRepository(\App\Entity\User::class)->find($user_id);
            $user->setSubscription($subscription);

            $manager->persist($user);
        }
        $manager->flush();
    }

    private function getSubscriptionData(): array
    {
        return [
            [1, Subscription::getPlanDataNameByIndex(2), (new \DateTime())->modify('+100 hour'), 'paid', false],
            [1, Subscription::getPlanDataNameByIndex(2), (new \DateTime())->modify('+100 year'), 'paid', false],
            [1, Subscription::getPlanDataNameByIndex(2), (new \DateTime())->modify('+100 year'), 'paid', false],
        ];
    }
}