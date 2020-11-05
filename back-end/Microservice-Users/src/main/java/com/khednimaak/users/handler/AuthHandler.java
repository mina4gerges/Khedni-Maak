package com.khednimaak.users.handler;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.server.ServerRequest;
import org.springframework.web.reactive.function.server.ServerResponse;

import com.khednimaak.users.dto.ApiResponse;
import com.khednimaak.users.dto.LoginRequest;
import com.khednimaak.users.dto.LoginResponse;
import com.khednimaak.users.model.User;
import com.khednimaak.users.repo.UserRepository;

import reactor.core.publisher.Mono;

import static org.springframework.http.MediaType.APPLICATION_JSON;

@Component
public class AuthHandler {

    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    @Autowired
    private TokenProvider tokenProvider;

    @Autowired
    private UserRepository userRepository;

    public AuthHandler(UserRepository userRepository, BCryptPasswordEncoder passwordEncoder){
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public Mono<ServerResponse> login(ServerRequest request) {
        Mono<LoginRequest> loginRequest = request.bodyToMono(LoginRequest.class);
        return loginRequest.flatMap(login -> userRepository.findByUsername(login.getUsername())
            .flatMap(user -> {
                if (passwordEncoder.matches(login.getPassword(), user.getPassword())) {
                    return ServerResponse.ok().contentType(APPLICATION_JSON).body(BodyInserters.fromObject(new LoginResponse(tokenProvider.generateToken(user))));
                } else {
                    return ServerResponse.badRequest().body(BodyInserters.fromObject(new ApiResponse(400, "Invalid credentials", null)));
                }
            }).switchIfEmpty(ServerResponse.badRequest().body(BodyInserters.fromObject(new ApiResponse(400, "User does not exist", null)))));
    }

    public Mono<ServerResponse> signUp(ServerRequest request) {
        Mono<User> userMono = request.bodyToMono(User.class);
        return userMono.map(user -> {
            user.setPassword(passwordEncoder.encode(user.getPassword()));
            return user;
        }).flatMap(user -> userRepository.findByUsername(user.getUsername())
                .flatMap(dbUser -> ServerResponse.badRequest().body(BodyInserters.fromObject(new ApiResponse(400, "User already exist", null))))
                .switchIfEmpty(userRepository.save(user).flatMap(savedUser -> ServerResponse.ok().contentType(APPLICATION_JSON).body(BodyInserters.fromObject(savedUser)))));
    }
}
