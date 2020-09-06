package com.khednimaak.khednimaak.user.controller;
 
import com.khednimaak.khednimaak.user.domain.User;
import com.khednimaak.khednimaak.user.repository.UserRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import javax.validation.Valid;


@RestController
//@RequestMapping("/api/v1")
public class UserController {
	@Autowired
	private UserRepository userRepository;
	


	@GetMapping("/users")
	public Flux<User> getAllUsers() {
		return userRepository.findAll();
	}
	
    @PostMapping("/users")
    public Mono<User> createUsers(@Valid @RequestBody User user) {
        return userRepository.save(user);
    }

    @GetMapping("/users/{id}")
    public Mono<ResponseEntity<User>> getUserById(@PathVariable(value = "id") String userId) {
        return userRepository.findById(userId)
                .map(savedUser -> ResponseEntity.ok(savedUser))
                .defaultIfEmpty(ResponseEntity.notFound().build());
    }
    
    @PutMapping("/users/{id}")
    public Mono<ResponseEntity<User>> updateUser(@PathVariable(value = "id") String userId,
                                                   @Valid @RequestBody User user) {
        return userRepository.findById(userId)
                .flatMap(existingUser -> {
                    existingUser.setId(user.getId());
                    return userRepository.save(existingUser);
                })
                .map(updatedUser -> new ResponseEntity<>(updatedUser, HttpStatus.OK))
                .defaultIfEmpty(new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    @DeleteMapping("/users/{id}")
    public Mono<ResponseEntity<Void>> deleteUser(@PathVariable(value = "id") String userId) {

        return userRepository.findById(userId)
                .flatMap(existingUser->
                        userRepository.delete(existingUser)
                            .then(Mono.just(new ResponseEntity<Void>(HttpStatus.OK)))
                )
                .defaultIfEmpty(new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }
    
 // Users are Sent to the client as Server Sent Events
    @GetMapping(value = "/stream/users", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<User> streamAllUsers() {
        return userRepository.findAll();
    }
}

