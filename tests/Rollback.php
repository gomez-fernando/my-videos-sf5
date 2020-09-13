<?php

namespace App\Tests;

trait Rollback {
    public function setUp()
    {
        $this->client = static::createClient([], [
            'PHP_AUTH_USER' => 'jm@symf5.loc',
            'PHP_AUTH_PW' => '12'
        ]);

        $this->entityManager = $this->client->getContainer()->get('doctrine.orm.entity_manager');
    }

//    public function tearDown()
//    {
//        parent::tearDown();
//        $this->entityManager->close();
//        $this->entityManager = null;  // avoid memory leaks
//    }
}