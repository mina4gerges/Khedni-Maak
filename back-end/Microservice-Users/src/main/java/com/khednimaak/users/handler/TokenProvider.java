package com.khednimaak.users.handler;

import io.jsonwebtoken.*;
import org.springframework.stereotype.Component;

import com.khednimaak.users.model.Role;
import com.khednimaak.users.model.User;

import static com.khednimaak.users.util.Constant.*;

import java.io.Serializable;
import java.util.Date;
import java.util.List;
import java.util.function.Function;
import java.util.stream.Collectors;

@Component
public class TokenProvider implements Serializable {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public String getUsernameFromToken(String token) {
        return getClaimFromToken(token, Claims::getSubject);
    }

    public Date getExpirationDateFromToken(String token) {
        return getClaimFromToken(token, Claims::getExpiration);
    }

    public <T> T getClaimFromToken(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = getAllClaimsFromToken(token);
        return claimsResolver.apply(claims);
    }

    public Claims getAllClaimsFromToken(String token) {
        return Jwts.parser()
                .setSigningKey(SIGNING_KEY)
                .parseClaimsJws(token)
                .getBody();
    }

    public Boolean isTokenExpired(String token) {
        final Date expiration = getExpirationDateFromToken(token);
        return expiration.before(new Date());
    }

    public String generateToken(User user) {
        final List<String> authorities = user.getRoles().stream()
                .map(Role::getName)
                .collect(Collectors.toList());
        return Jwts.builder()
                .setSubject(user.getUsername())
                .claim(AUTHORITIES_KEY, authorities)
                .signWith(SignatureAlgorithm.HS256, SIGNING_KEY)
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis() + ACCESS_TOKEN_VALIDITY_SECONDS*1000))
                .compact();
    }

}
