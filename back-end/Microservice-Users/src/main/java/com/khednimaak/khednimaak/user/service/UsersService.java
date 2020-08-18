package com.khednimaak.khednimaak.user.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.khednimaak.khednimaak.user.entity.Users;
import com.khednimaak.khednimaak.user.repository.UsersRepository;



@Service
public class UsersService {
	@Autowired
	private UsersRepository repository;

	public Users saveUser(Users user) {
		return repository.save(user);
	}
	
	public List<Users> saveUsers(List<Users>users) {
		return repository.saveAll(users);
	}
	
	public List<Users> getUsers() {
		return repository.findAll();
	}
	
	public Users getUserById(int id) {
		return repository.findById(id).orElse(null);
				
	}
	
	public Users getUserByName(String name) {
		return repository.findByName(name);
	}
	
    public String deleteUser(int id) {
        repository.deleteById(id);
        return "user removed !! " + id;
    }

    public Users updateUser(Users user) {
        Users existingUser = repository.findById(user.getId()).orElse(null);
        existingUser.setName(user.getName());
        existingUser.setMobile(user.getMobile());
        existingUser.setEmail(user.getEmail());
        existingUser.setAddress(user.getAddress());
        return repository.save(existingUser);
    }
	
}
