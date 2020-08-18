package com.khednimaak.khednimaak.user.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.khednimaak.khednimaak.user.entity.Users;

public interface UsersRepository extends JpaRepository<Users, Integer>{
	Users findByName(String name);
}


