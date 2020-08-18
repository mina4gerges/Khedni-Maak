package com.khednimaak.khednimaak.user.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import com.khednimaak.khednimaak.user.entity.Users;
import com.khednimaak.khednimaak.user.service.UsersService;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class UsersController {

	@Autowired
	private UsersService service;
	
	@PostMapping("/addUser")
	public Users addUser(@RequestBody Users user) {
		return service.saveUser(user);  
	}
	
	@PostMapping("/addUsers")
	public List<Users> addUsers(@RequestBody List<Users> user) {
		return service.saveUsers(user);  
	}
    @GetMapping("/users")
    public List<Users> findAllUsers() {
        return service.getUsers();
    }

    @GetMapping("/userById/{id}")
    public Users findUserById(@PathVariable int id) {
        return service.getUserById(id);
    }

    @GetMapping("/user/{name}")
    public Users findUserByName(@PathVariable String name) {
        return service.getUserByName(name);
    }

    @PutMapping("/update")
    public Users updateUser(@RequestBody Users user) {
        return service.updateUser(user);
    }

    @DeleteMapping("/delete/{id}")
    public String deleteUser(@PathVariable int id) {
        return service.deleteUser(id);
    }
}
