package com.ohadr.security.oauth.examples.impl;

import com.ohadr.security.oauth.examples.DemoService;

import java.net.URI;


public class DemoServiceImpl implements DemoService
{

    @Override
    public String getTrustedMessage()
    {
        String demo = "say hi bitch";
        return demo;
    }
}
