package com.khednimaak.users.repo;

import org.springframework.data.mongodb.repository.ReactiveMongoRepository;

import com.khednimaak.users.model.User;

import reactor.core.publisher.Mono;

public interface UserRepository extends ReactiveMongoRepository<User, String> {

    Mono<User> findByUsername(String username);
}
