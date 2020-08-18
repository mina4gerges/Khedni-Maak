package com.khednimaak.khednimaak.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.khednimaak.khednimaak.entity.Users;

public interface UsersRepository extends JpaRepository<Users, Integer>{
	Users findByName(String name);
}


