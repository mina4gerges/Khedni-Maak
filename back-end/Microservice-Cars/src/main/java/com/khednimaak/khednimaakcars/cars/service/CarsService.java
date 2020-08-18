package com.khednimaak.khednimaakcars.cars.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import com.khednimaak.khednimaakcars.cars.entity.Cars;
import com.khednimaak.khednimaakcars.cars.repository.CarsRepository;

@Service
public class CarsService {
	@Autowired
	private CarsRepository repository;
	
	public List<Cars> getCars() {
	return repository.findAll();
	}
	
}
