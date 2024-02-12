<?php

namespace Tests\Unit;

use Tests\BaseTestClass;

class ExampleTest extends BaseTestClass
{
    /**
     * @test
     */
    public function isADemoTestFunction()
    {
        $array = [1,2,3];

        $this->assertCount(3, $array);
    }
}
