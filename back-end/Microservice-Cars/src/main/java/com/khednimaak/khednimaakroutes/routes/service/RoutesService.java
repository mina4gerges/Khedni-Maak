package com.khednimaak.khednimaakroutes.routes.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.khednimaak.khednimaakroutes.routes.entity.Routes;
import com.khednimaak.khednimaakroutes.routes.repository.RoutesRepository;



@Service
public class RoutesService {
	@Autowired
	private RoutesRepository repository;
	
	public List<Routes> getRoutes() {
	return repository.findAll();
	}

	public Routes getRouteById(int id) {
		return repository.findById(id).orElse(null);
				
	}

	public Routes saveRoute(Routes route) {
		return repository.save(route);
	}
	
    public String deleteRoute(int id) {
        repository.deleteById(id);
        return "route removed !! " + id;
    }

//    public Routes updateRoute(Routes route) {
//        Routes existingRoute = repository.findById(route.getId()).orElse(null);
//        existingRoute.setName(route.getName());
//        existingRoute.setMobile(route.getMobile());
//        existingRoute.setEmail(route.getEmail());
//        existingRoute.setAddress(route.getAddress());
//        return repository.save(existingRoute);
//    }
}
