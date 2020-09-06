package com.khednimaak.khednimaak.user.controller;

import java.util.List;

import org.apache.catalina.startup.ClassLoaderFactory.Repository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.jackson.JsonComponent;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;

import com.khednimaak.khednimaak.user.entity.Users;
import com.khednimaak.khednimaak.user.repository.UsersRepository;
import com.khednimaak.khednimaak.user.service.UsersService;

import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.reactive.function.client.WebClient;



@RestController
public class UsersController {

	@Autowired
	private UsersRepository repository;
	private UsersService service;
	
	@PostMapping("/addUser")
	public Users addUser(@RequestBody Users user) {
		return service.saveUser(user);  
	}
	
	@PostMapping("/addUsers")
	public List<Users> addUsers(@RequestBody List<Users> user) {
		return service.saveUsers(user);  
	}
    @GetMapping("/users")
    public List<Users> findAllUsers() {
        return service.getUsers();
    }

    @GetMapping("/userById/{id}")
    public Users findUserById(@PathVariable int id) {
        return service.getUserById(id);
    }
   
    
    ///New Code 
    @Autowired
    private WebClient.Builder webClientBuilder;
    
    
    @RequestMapping("/userById2/{id}")
    public Mono<Users> findUserById2(int id) {
    return ((WebClient) webClientBuilder).get()
            .uri("/employees/" + id)
            .retrieve()
            /*.onStatus(httpStatus -> HttpStatus.NOT_FOUND.equals(httpStatus),
                    clientResponse -> Mono.empty())*/
            .bodyToMono(Users.class);
    }
    
//    @GetMapping("/userByIdAdv/{id}")
//    public Object[] findUserByIdAdv(@PathVariable int id) {
//    	
//    	Users samer = service.getUserById(id);
//    	int carid = samer.getCarid();
//        
//    	String baseurl="http://localhost:9292/carById/"+carid;
//        
//    	RestTemplate restTemplate = new RestTemplate();
//		ResponseEntity<Object[]> responseEntity = restTemplate.exchange(baseurl, HttpMethod.GET, getHeaders(),Object[].class);
//		
//		
//		Object[] objects = responseEntity.getBody();
//		
//    	System.out.println(objects);
//    	
//    	return objects;
//    }
    
    
    
	private static HttpEntity<?> getHeaders() {
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		return null;
	}
    
    
//    @GetMapping("/user/{name}")
//    public Users findUserByName(@PathVariable String name) {
//        return service.getUserByName(name);
//    }

    @PutMapping("/update")
    public Users updateUser(@RequestBody Users user) {
        return service.updateUser(user);
    }

    @DeleteMapping("/delete/{id}")
    public String deleteUser(@PathVariable int id) {
        return service.deleteUser(id);
    }
}
