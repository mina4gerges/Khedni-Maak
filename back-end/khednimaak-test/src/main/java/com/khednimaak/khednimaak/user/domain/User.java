package com.khednimaak.khednimaak.user.domain;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.util.Date;


@Document (collection = "user")
public class User {

	 @Id
     private String id;
	
	 @NotBlank
	 @Size(max = 20)
	 private String firstName;
	 
	 @NotBlank
	 @Size(max = 30)
	 private String lastName;
	 
	 @NotBlank
	 @Size(max = 50)
	 private String email;
	 
	 @NotNull
	 private Date createdAt = new Date();

	 public User() {

	 }

	 public User(String firstName, String lastName, String email){
	        this.id = id;
	        this.firstName = firstName;
	        this.lastName = lastName;
	        this.email = email;
	}
	 
	 
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}

	
}