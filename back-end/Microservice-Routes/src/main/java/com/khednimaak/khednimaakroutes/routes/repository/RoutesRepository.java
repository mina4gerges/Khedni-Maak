package com.khednimaak.khednimaakroutes.routes.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.khednimaak.khednimaakroutes.routes.entity.Routes;


public interface RoutesRepository extends JpaRepository<Routes, Integer>{
	@Query("SELECT t.destination FROM routes_tbl t where t.username =: username")
	String findRoutebyUsername(@Param("username") String username);
}


