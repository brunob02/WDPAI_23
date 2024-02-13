<?php

require_once 'AppController.php';

class DefaultController extends AppController
{

    public function index()
    {
        $this->render('index');
    }

    public function history()
    {
        $this->render('history');
    }

    public function star()
    {
        $this->render('star');
    }
}