package com.khednimaak.khednimaak.user.repository;

import org.springframework.data.mongodb.repository.ReactiveMongoRepository;
import org.springframework.stereotype.Repository;

import com.khednimaak.khednimaak.user.domain.User;

@Repository
public interface UserRepository extends ReactiveMongoRepository<User, String>{

}
