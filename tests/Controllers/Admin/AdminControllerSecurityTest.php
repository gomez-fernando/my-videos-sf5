<?php

namespace App\Tests;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;
use Symfony\Component\HttpFoundation\Response;

class AdminControllerSecurityTest extends WebTestCase
{
    /**
     * @dataProvider getUrlsForRegularUsers
     */
    public function testAccessDeniedForRegularUsers(string $httpMethod, string $url)
    {
        $client = static::createClient([], [
            'PHP_AUTH_USER' => 'mg@symf5.loc',
            'PHP_AUTH_PW' => '12'
        ]);
        $client->request($httpMethod, $url);
        $this->assertSame(Response::HTTP_FORBIDDEN, $client->getResponse()->getStatusCode());
    }

    public function getUrlsForRegularUsers()
    {
        yield ['GET', '/admin/su/categories'];
        yield ['GET', '/admin/su/edit-category/1'];
        yield ['GET', '/admin/su/delete-category/1'];
        yield ['GET', '/admin/su/users'];
        yield ['GET', '/admin/su/upload-video'];
    }

    public function testAdminSu()
    {
        $client = static::createClient([], [
            'PHP_AUTH_USER' => 'jm@symf5.loc',
            'PHP_AUTH_PW' => '12'
        ]);
        $crawler = $client->request('GET', '/admin/su/categories');
        $this->assertSame('Categories list', $crawler->filter('h2')->text());
    }
}
