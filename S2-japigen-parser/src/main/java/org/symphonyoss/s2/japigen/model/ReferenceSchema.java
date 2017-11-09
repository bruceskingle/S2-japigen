/*
 *
 *
 * Copyright 2017 Symphony Communication Services, LLC.
 *
 * Licensed to The Symphony Software Foundation (SSF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package org.symphonyoss.s2.japigen.model;

import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;

import org.symphonyoss.s2.japigen.parser.ParserContext;
import org.symphonyoss.s2.japigen.parser.ParsingException;

/**
 * A schema defined as
 * 
 * <code><pre>
  {
    "$ref": "#/some/URI"
  }
 * </pre></code>
 * 
 * In order to allow forward references these objects need to be first created and then
 * resolved in a second pass of the model.
 * 
 * @author Bruce Skingle
 *
 */
public class ReferenceSchema extends ReferenceOrSchema
{
  private URI uri_;
  private Schema    reference_;
  private String    path_;
  private String    fragment_;
  private URI       baseUri_;
  
  public ReferenceSchema(ModelElement parent, ParserContext context, ParserContext node)
  {
    super(parent, context, "Ref");
    try
    {
      uri_ = new URI(node.getJsonNode().asText());
      
      path_ = uri_.getPath();
      fragment_ = uri_.getFragment();
      
      String s = uri_.toString();
      int i = s.indexOf('#');
      
      if(i== -1)
        baseUri_ = uri_;
      else
      {
        try
        {
          baseUri_ = new URI(s.substring(0, i));
        }
        catch (URISyntaxException e)
        {
          context.error("Invalid base URI \"%s\"", s.substring(0, i));
        }
      }
      
      if(path_.length()>0)
      {
        context.getRootParserContext().addReferencedModel(baseUri_, context);
      }
    }
    catch (URISyntaxException | ParsingException e)
    {
      context.error("Invalid URI \"%s\"", node.getJsonNode().asText());
    }
    
  }
  
  

  @Override
  public void validate()
  {
    super.validate();
    
    if(path_ != null)
    {
      ModelElement referent;
      
      if(path_.length()>0)
      {
        Model model = getContext().getRootParserContext().getModel(baseUri_);
        
        referent = fragment_.startsWith("/") ?
            model.getByPath(fragment_.split("/"), 1) :
              model.getByPath(fragment_.split("/"), 0); 
      }
      else
      {
        referent = fragment_.startsWith("/") ?
            getModel().getByPath(fragment_.split("/"), 1) :
            getByPath(fragment_.split("/"), 0); 
      }  
      if(referent == null)
        getContext().error("Referenced schema \"%s\" not found.", uri_);
      else if(referent instanceof Schema)
        reference_ = (Schema) referent;
      else
        getContext().error("Referenced schema \"%s\" is not a schema but a %s", uri_, referent.getClass().getName());
    }
  }

  public boolean  isResolved()
  {
    return reference_ != null;
  }

  public URI getUri()
  {
    return uri_;
  }

  public Schema getReference()
  {
    return reference_;
  }
  
  @Override
  public String toString()
  {
    return super.toString(new ValueMap<String, Object>()
        .append("uri", uri_, null));
  }
}
