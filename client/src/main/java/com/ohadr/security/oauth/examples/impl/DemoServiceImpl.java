package com.ohadr.security.oauth.examples.impl;

import com.ohadr.security.oauth.examples.DemoService;


public class DemoServiceImpl implements DemoService
{

    public String getTrustedMessage()
    {
        String demo = "It works!";
        return demo;
    }
}
