package com.khednimaak.khednimaakroutes;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
@EnableDiscoveryClient
@SpringBootApplication
public class KhednimaakCarsApplication {

	public static void main(String[] args) {
		SpringApplication.run(KhednimaakCarsApplication.class, args);
	}

}
