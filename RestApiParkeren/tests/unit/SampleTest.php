<?php 

use PHPUnit\Framework\TestCase;
use PHPUnit\DbUnit\TestCaseTrait;


class UserAgentTest extends PHPUnit\Framework\TestCase
{
    private $http;

    public function setUp() : void
    {
        $this->http = new GuzzleHttp\Client(['base_uri' => 'http://invalideparkeren.nl/']);
    }

    public function tearDown(): void {
        $this->http = null;
    }

    public function testGet()
    {
        $response = $this->http->request('GET', 'api/parkingplace/read.php');

        $this->assertEquals(200, $response->getStatusCode());

        $response = $this->http->request('GET', 'api/parkingplace/read_nearby.php?Lat=52.071510&Lon=4.495053&Rad=0.5');

        $this->assertEquals(200, $response->getStatusCode());

        $response = $this->http->request('GET', 'api/parkingplace/read_nearby.php?Lat=52.071510&Lon=4.495053&Rad=0.0',['http_errors'=> false]);

        $this->assertEquals(404, $response->getStatusCode());

    }

}