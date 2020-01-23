package com.aikon.servlets;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.aikon.iengage.api.IEngageAPI;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.iengage.client.model.FlowFinder;
import com.iengage.client.model.Keyword;
import com.iengage.client.model.TextClassification;
import com.iengage.client.model.VerveResponseFlowFinder;
import com.iengage.client.model.VerveResponseKeyword;
import com.iengage.client.model.VerveResponseSentiment;
import com.iengage.client.model.VerveResponseTextClassificationList;



public class IEngageDemoServlet extends HttpServlet {

	private IEngageAPI api = new IEngageAPI();
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		System.out.println("Hello");
		super.doGet(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		System.out.println("Received Post request");
		String requestParameter = req.getParameter("requestParameter");
		if(requestParameter.equalsIgnoreCase("getTags")) {
			String inputText = req.getParameter("text");
			System.out.println(inputText);
			VerveResponseKeyword tags = api.getKeywords(inputText);
			VerveResponseTextClassificationList classification = api.classifyText(inputText);
			VerveResponseSentiment sentiments = api.getSentiments(inputText);
			VerveResponseFlowFinder types = api.getInteractionType(inputText);
			PrintWriter out = resp.getWriter();
			JsonObject json = new JsonObject();
			if(tags!=null) {
				JsonArray tagArray = new JsonArray();
				for(Keyword k:tags.getList()) {
					tagArray.add(k.getKey());
				}
				json.add("tags", tagArray);
			}
			else {
				json.addProperty("tags", "NOT_FOUND");
			}
			if(classification!=null) {
				JsonArray classificationArray = new JsonArray();
				for(TextClassification a:classification.getList()) {
					JsonObject temp = new JsonObject();
					temp.addProperty("confidence", a.getConfidence());
					temp.addProperty("name", a.getName());
					classificationArray.add(temp);
				}
				json.add("classification", classificationArray);
			}else {
				json.addProperty("classification", "NOT_FOUND");
			}
			if(sentiments!=null) {
				json.addProperty("sentiment", sentiments.getData().getSentiment());
			}else {
				json.addProperty("sentiment", "NOT_FOUND");
			}
			if(types!=null) {
				Gson gson = new Gson();
				String interactionType = gson.toJson(types.getData());
				JsonObject obj = null;
				JsonParser parser = new JsonParser();
				JsonElement el = parser.parse(interactionType);
				json.add("types", el);
			}else {
				json.addProperty("types", "NOT_FOUND");
			}
			System.out.println(">>>>>>>>>>>>>>>>>>>"+json.toString());
			out.write(json.toString());
			out.flush();
			out.close();
		}
		
	}

}
