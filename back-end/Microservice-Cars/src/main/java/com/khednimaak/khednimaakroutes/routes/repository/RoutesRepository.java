package com.khednimaak.khednimaakroutes.routes.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.khednimaak.khednimaakroutes.routes.entity.Routes;


public interface RoutesRepository extends JpaRepository<Routes, Integer>{
	
}


