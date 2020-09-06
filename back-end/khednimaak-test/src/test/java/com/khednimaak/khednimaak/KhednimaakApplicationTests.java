package com.khednimaak.khednimaak;

import com.khednimaak.khednimaak.user.domain.User;
import com.khednimaak.khednimaak.user.repository.UserRepository;

import org.junit.Test;
import org.junit.runner.RunWith;

//import org.assertj.core.api.Assertions;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.reactive.server.WebTestClient;
import reactor.core.publisher.Mono;

//import java.util.Collections;

@RunWith(SpringRunner.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class KhednimaakApplicationTests {

	@Autowired
	private WebTestClient webTestClient;

	@Autowired
    UserRepository userRepository;

	@Test
	public void testCreateUser() {
		User user = new User("samer","barhouche","samer.barhouche@gmail.com");

		webTestClient.post().uri("/users")
				.contentType(MediaType.APPLICATION_JSON_UTF8)
                .accept(MediaType.APPLICATION_JSON_UTF8)
                .body(Mono.just(user), User.class)
				.exchange()
				.expectStatus().isOk()
				.expectHeader().contentType(MediaType.APPLICATION_JSON_UTF8)
				.expectBody()
                .jsonPath("$.id").isNotEmpty()
                .jsonPath("$.firstName").isEqualTo("samer")
                .jsonPath("$.lastName").isEqualTo("barhouche")
                .jsonPath("$.email").isEqualTo("samer.barhouche@gmail.com");
	}
//
//	@Test
//    public void testGetAllUsers() {
//	    webTestClient.get().uri("/tweets")
//                .accept(MediaType.APPLICATION_JSON_UTF8)
//                .exchange()
//                .expectStatus().isOk()
//                .expectHeader().contentType(MediaType.APPLICATION_JSON_UTF8)
//                .expectBodyList(Tweet.class);
//    }
//
//    @Test
//    public void testGetSingleTweet() {
//        Tweet tweet = tweetRepository.save(new Tweet("Hello, World!")).block();
//
//        webTestClient.get()
//                .uri("/tweets/{id}", Collections.singletonMap("id", tweet.getId()))
//                .exchange()
//                .expectStatus().isOk()
//                .expectBody()
//                .consumeWith(response ->
//                        Assertions.assertThat(response.getResponseBody()).isNotNull());
//    }
//
//    @Test
//    public void testUpdateTweet() {
//        Tweet tweet = tweetRepository.save(new Tweet("Initial Tweet")).block();
//
//        Tweet newTweetData = new Tweet("Updated Tweet");
//
//        webTestClient.put()
//                .uri("/tweets/{id}", Collections.singletonMap("id", tweet.getId()))
//                .contentType(MediaType.APPLICATION_JSON_UTF8)
//                .accept(MediaType.APPLICATION_JSON_UTF8)
//                .body(Mono.just(newTweetData), Tweet.class)
//                .exchange()
//                .expectStatus().isOk()
//                .expectHeader().contentType(MediaType.APPLICATION_JSON_UTF8)
//                .expectBody()
//                .jsonPath("$.text").isEqualTo("Updated Tweet");
//    }
//
//    @Test
//    public void testDeleteTweet() {
//	    Tweet tweet = tweetRepository.save(new Tweet("To be deleted")).block();
//
//	    webTestClient.delete()
//                .uri("/tweets/{id}", Collections.singletonMap("id",  tweet.getId()))
//                .exchange()
//                .expectStatus().isOk();
//    }
}