package com.ohadr.security.oauth.examples.impl;

import com.ohadr.security.oauth.examples.DemoService;


public class DemoServiceImpl implements DemoService
{

    public String getTrustedMessage()
    {
        String demo = "say hi bitch";
        return demo;
    }
}
