package com.aikon.iengage.api;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Properties;

import com.google.gson.JsonSyntaxException;
import com.iengage.ApiClient;
import com.iengage.ApiException;
import com.iengage.Configuration;
import com.iengage.auth.OAuth;
import com.iengage.client.model.VerveResponseFlowFinder;
import com.iengage.client.model.VerveResponseKeyword;
import com.iengage.client.model.VerveResponseSentiment;
import com.iengage.client.model.VerveResponseTextClassificationList;
import com.iengage.service.AugmentedIntelligenceApi;

public class IEngageAPI {

	private final String userName;
	private final String accessToken;
	private final String clientToken;
	
	public IEngageAPI() {
		Properties props = new Properties();
		try {
			props.load(Thread.currentThread().getContextClassLoader().getResourceAsStream("demo.properties"));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		userName = props.getProperty("iengage.api.demo.default.user");
		clientToken = props.getProperty("iengage.api.demo.default.clienttoken");
		accessToken = props.getProperty("iengage.api.demo.default.accesstoken");
		
	}
	
	public VerveResponseKeyword getKeywords(String text) {
		
		ApiClient defaultClient = Configuration.getDefaultApiClient();
        
        // Configure OAuth2 access token for authorization: default
		OAuth def = (OAuth) defaultClient.getAuthentication("default");
		def.setAccessToken(accessToken);

		AugmentedIntelligenceApi apiInstance = new AugmentedIntelligenceApi();
		try {
		    VerveResponseKeyword result = apiInstance.getKeywords(text, clientToken);
//		    Gson gson = new Gson();
//		    System.out.println(result.toString());
		    return result;
		} catch (ApiException e) {
		    System.err.println("Exception when calling AugmentedIntelligenceApi#getKeywords");
		    e.printStackTrace();
		}  catch (JsonSyntaxException e) {
			return null;
		}
		return null;
	}
	
	public VerveResponseTextClassificationList classifyText(String text) {
		ApiClient defaultClient = Configuration.getDefaultApiClient();

		// Configure OAuth2 access token for authorization: default
		OAuth def = (OAuth) defaultClient.getAuthentication("default");
		def.setAccessToken(accessToken);

		AugmentedIntelligenceApi apiInstance = new AugmentedIntelligenceApi();
		Long id = 893765L; //without label data
		try {
		    VerveResponseTextClassificationList result = apiInstance.classify(text, id, clientToken);
		   // System.out.println(result);
		    return result;
		} catch (ApiException e) {
		    System.err.println("Exception when calling AugmentedIntelligenceApi#classify");
		    e.printStackTrace();
		} catch (JsonSyntaxException e) {
			return null;
		}
		return null;
	}
	
	public VerveResponseSentiment getSentiments(String text) {
		ApiClient defaultClient = Configuration.getDefaultApiClient();

		// Configure OAuth2 access token for authorization: default
		OAuth def = (OAuth) defaultClient.getAuthentication("default");
		def.setAccessToken(accessToken);

		AugmentedIntelligenceApi apiInstance = new AugmentedIntelligenceApi();
		try {
		    VerveResponseSentiment result = apiInstance.sentiment(text, clientToken);
		  //  System.out.println(result);
		    return result;
		} catch (ApiException e) {
		    System.err.println("Exception when calling AugmentedIntelligenceApi#sentiment");
		    e.printStackTrace();
		} catch (JsonSyntaxException e) {
			return null;
		}
		return null;
	}
	
	public VerveResponseFlowFinder getInteractionType(String text) {
		ApiClient defaultClient = Configuration.getDefaultApiClient();

		// Configure OAuth2 access token for authorization: default
		OAuth def = (OAuth) defaultClient.getAuthentication("default");
		def.setAccessToken(accessToken);

		AugmentedIntelligenceApi apiInstance = new AugmentedIntelligenceApi();
		try {
		    VerveResponseFlowFinder result = apiInstance.getInteractionType(text, clientToken);
		  //  System.out.println(result);
		    return result;
		} catch (ApiException e) {
		    System.err.println("Exception when calling AugmentedIntelligenceApi#getInteractionType");
		    e.printStackTrace();
		} catch (JsonSyntaxException e) {
			return null;
		}
		return null;
	}

}

