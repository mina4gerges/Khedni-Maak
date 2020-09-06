package com.khednimaak.khednimaakcars.cars.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.khednimaak.khednimaakcars.cars.entity.Cars;


public interface CarsRepository extends JpaRepository<Cars, Integer>{
	
}


