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

import com.symphony.s2.japigen.runtime.exception.JapiException;

/**
 * A handler for some async method which takes a payload and returns a response.
 * 
 * @author Bruce Skingle
 *
 * @param <P>   The type of the payload.
 * @param <R>   The type of the response.
 */
public interface IPayloadResponseRequestManager<P, R>
{
  void handle(P payload, IConsumer<R> consumer) throws JapiException;
}
