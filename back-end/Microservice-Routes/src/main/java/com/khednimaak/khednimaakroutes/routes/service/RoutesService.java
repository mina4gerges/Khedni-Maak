package com.khednimaak.khednimaakroutes.routes.service;

import java.util.ArrayList;
import java.util.List;

import org.bouncycastle.math.ec.ECAlgorithms;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.khednimaak.khednimaakroutes.routes.entity.Routes;
import com.khednimaak.khednimaakroutes.routes.repository.RoutesRepository;
import com.sun.org.apache.bcel.internal.generic.RETURN;



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

	public Routes updateRoutePassenger(Routes route) {

	        Routes existingRoute = repository.findById(route.getId()).orElse(null);
	        ArrayList<String> passenger = route.getPassengers();
	        
	         for (String pass : existingRoute.getPassengers()) {
				passenger.add(pass);
			}
	        
	        existingRoute.setPassengers(passenger);
	        return repository.save(existingRoute);

	}
	
	
	public Routes updateRouteStatus(Routes route) {
	Routes existingRoute = repository.findById(route.getId()).orElse(null);
	existingRoute.setStatus(0);
	return repository.save(existingRoute);
	}
	
	

//	public String getRoutesByUsername(String username) {
//		return repository.findRoutebyUsername(username);
//	}
    
//    public Routes updateRoute(Routes route) {
//        Routes existingRoute = repository.findById(route.getId()).orElse(null);
//        existingRoute.setName(route.getName());
//        existingRoute.setMobile(route.getMobile());
//        existingRoute.setEmail(route.getEmail());
//        existingRoute.setAddress(route.getAddress());
//        return repository.save(existingRoute);
//    }
}
