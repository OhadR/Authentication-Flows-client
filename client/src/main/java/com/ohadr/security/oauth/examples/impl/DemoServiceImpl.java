package com.ohadr.security.oauth.examples.impl;

import org.springframework.stereotype.Component;

import com.ohadr.security.oauth.examples.DemoService;


@Component
public class DemoServiceImpl implements DemoService
{

    public String getTrustedMessage()
    {
        String demo = "It Works!!";
        return demo;
    }
}
