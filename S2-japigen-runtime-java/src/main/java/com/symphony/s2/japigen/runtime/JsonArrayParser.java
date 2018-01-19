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

package com.symphony.s2.japigen.runtime;

import java.io.ByteArrayOutputStream;
import java.nio.charset.StandardCharsets;

/**
 * A parser which takes byte buffers and accumulates a JSON document.
 * 
 * If the document is a JSON array then each element of the array is passed to the 
 * handle method, one at time. Otherwise the entire document is passed to the
 * handle method.
 * 
 * This is intended to be used as a pre-processor to a JSON parser (e.g. Jackson)
 * so that streaming processing of multiple instance payloads can be implemented.
 * 
 * @author Bruce Skingle
 *
 */
public abstract class JsonArrayParser
{
  private ByteArrayOutputStream     inputBufferStream_ = new ByteArrayOutputStream();
  private boolean                   inQuotedString_;
  private boolean                   inEscape_;
  private boolean                   arrayDocument_;
  private int                       arrayDepth_;
  private int                       objectDepth_;
  
  public void process(byte[] inputBuffer_, int nbytes)
  {   
    int offset=0;
    int len=0;
    int i=0;
    
    while(i<nbytes)
    {
      if(inQuotedString_)
      {
        switch(inputBuffer_[i])
        {
          case '\\':
            inEscape_ = !inEscape_;
            break;
            
          case '"':
            if(inEscape_)
              inEscape_ = false;
            else
              inQuotedString_ = false;
            break;
        }
      }
      else
      {
        switch(inputBuffer_[i])
        {
          case '"':
            inQuotedString_ = true;
            break;
          
          case '{':
            objectDepth_++;
            break;
          
          case '}':
            objectDepth_--;
            break;
            
          case '[':
            if(objectDepth_==0 && arrayDepth_==0)
            {
              // This is the start of an array document
              offset = i+1;
              len -= offset;
              arrayDocument_ = true;
            }
            arrayDepth_++;
            break;
            
          case ']':
            arrayDepth_--;
            break;
            
          case ',':
            if(arrayDepth_==1 && objectDepth_==0)
            {
              inputBufferStream_.write(inputBuffer_, offset, len);
              
              String input = new String(inputBufferStream_.toByteArray(), StandardCharsets.UTF_8);
              
              System.err.println("Got input " + input);
              handle(input);
              
              inputBufferStream_.reset();
              
              len = -1;
              offset = i+1;
            }
            break;
        }
      }
      i++;
      len++;
    }
    if(len>0)
    {
      if(arrayDocument_ && inputBuffer_[offset+len-1]==']')
        len--;
      
      inputBufferStream_.write(inputBuffer_, offset, len);
    }
  }
  

  protected abstract void handle(String input);


  public void close()
  {
    if(inputBufferStream_.size()>0)
    {
      String input = new String(inputBufferStream_.toByteArray(), StandardCharsets.UTF_8);
      
      System.err.println("Got input " + input);
      handle(input);
    }
  }
}
