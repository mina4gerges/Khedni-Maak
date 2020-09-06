package com.khednimaak.khednimaakcars.cars.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import reactor.core.publisher.Mono;

import com.khednimaak.khednimaakcars.cars.entity.Cars;
import com.khednimaak.khednimaakcars.cars.service.CarsService;




@RestController
public class CarsController {
	@Autowired
	private CarsService service;
	
	
	
    @GetMapping("/cars")
    public List<Cars> findAllCars() {
        return service.getCars();
    }
    
//    @GetMapping("/carsusers")
//    public String getUsers() {
//    	String baseurl="http://localhost:9191/users";
//    	
//    	RestTemplate restTemplate = new RestTemplate();
//    	ResponseEntity<String> response = null;
//    	
//    	response=restTemplate.exchange(baseurl, HttpMethod.GET, getHeaders(), String.class);
//    	
//    	System.out.println(response.getBody());
//    	
//    	return response.getBody().toString();    	
//    }

    
//    @GetMapping("/carsusers")
//    public Object[] getUsers() {
//    	String baseurl="http://localhost:9191/users";
//    
//    	RestTemplate restTemplate = new RestTemplate();
//		ResponseEntity<Object[]> responseEntity = restTemplate.exchange(baseurl, HttpMethod.GET, getHeaders(),Object[].class);
//		Object[] objects = responseEntity.getBody();
//		
//		System.out.println(objects);
//		return objects;
//    	 }
//    
    
    
    @GetMapping("/carById/{id}")
    public Cars findCarById(@PathVariable int id) {
        return service.getCarById(id);
    }
    
   
   
	private static HttpEntity<?> getHeaders() {
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		return null;
	}
    
    
    
}
