package com.khednimaak.khednimaakroutes.routes.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;


import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.ietf.jgss.Oid;



@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "routes_tbl")

public class Routes {
	@Id
	@GeneratedValue
    private int id;
	private String source;
    private String destination;
    private String estimationTime;
    private String startingTime; 
    private int status=1; // 1 for active, 0 for inactive 
    private int capacity; //maximum number of passengers
    private ArrayList<String> passengers = new ArrayList<String>();
    private String driverUsername; //name of the driver 
    private String car;

	
	public String getSource() {
		return source;
	}
	public void setSource(String source) {
		this.source = source;
	}
	public String getDestination() {
		return destination;
	}
	public void setDestination(String destination) {
		this.destination = destination;
	}


	public String getDriverUsername() {
		return driverUsername;
	}
	public void setDriverUsername(String driverUsername) {
		this.driverUsername = driverUsername;
	}
	public int getCapacity() {
		return capacity;
	}
	public void setCapacity(int capacity) {
		this.capacity = capacity;
	}
	public String getEstimationTime() {
		return estimationTime;
	}
	public void setEstimationTime(String estimationTime) {
		this.estimationTime = estimationTime;
	}
	public String getStartingTime() {
		return startingTime;
	}
	public void setStartingTime(String startingTime) {
		this.startingTime = startingTime;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getCar() {
		return car;
	}
	public void setCar(String car) {
		this.car = car;
	}
	public ArrayList<String> getPassengers() {
		return passengers;
	}
	public void setPassengers(ArrayList<String> passengers) {
		this.passengers = passengers;
	}

    
}
