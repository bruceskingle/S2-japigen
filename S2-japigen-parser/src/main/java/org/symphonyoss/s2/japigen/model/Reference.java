/*
 *
 *
 * Copyright 2018 Symphony Communication Services, LLC.
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

import java.net.URI;
import java.net.URISyntaxException;

import org.symphonyoss.s2.japigen.parser.ParserContext;
import org.symphonyoss.s2.japigen.parser.ParsingException;
import org.symphonyoss.s2.japigen.parser.error.ParserError;

public class Reference<T> extends ModelElement
{
  private final Class<T> type_;

  private URI            uri_;
  private String         path_;
  private String         fragment_;
  private URI            baseUri_;
  private T              referent_;
  
  public Reference(ModelElement parent, ParserContext context, Class<T> type)
  {
    super(parent, context, "Reference");
    
    type_ = type;
    
    try
    {
      uri_ = new URI(context.getJsonNode().asText());
      
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
          context.raise(new ParserError("Invalid base URI \"%s\"", s.substring(0, i)));
        }
      }
    }
    catch (URISyntaxException e)
    {
      context.raise(new ParserError("Invalid URI \"%s\"", context.getJsonNode().asText()));
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
        getContext().raise(new ParserError("Referenced %s \"%s\" not found.", type_.getName(), uri_));
      else if(type_.isInstance(referent))
        referent_ = type_.cast(referent);
      else
        getContext().raise(new ParserError("Referenced object \"%s\" is not a %s but a %s", type_.getName(), uri_, referent.getClass().getName()));
    }
  }

  public T getReferent()
  {
    return referent_;
  }

  public URI getUri()
  {
    return uri_;
  }

  public String getPath()
  {
    return path_;
  }

  public String getFragment()
  {
    return fragment_;
  }

  public URI getBaseUri()
  {
    return baseUri_;
  }
}
