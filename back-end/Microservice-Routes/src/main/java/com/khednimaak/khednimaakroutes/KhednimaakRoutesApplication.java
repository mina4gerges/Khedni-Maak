package com.khednimaak.khednimaakroutes;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
@EnableDiscoveryClient
@SpringBootApplication
public class KhednimaakRoutesApplication {

	public static void main(String[] args) {
		SpringApplication.run(KhednimaakRoutesApplication.class, args);
	}

}
