/*
 *
 *
 * Copyright 2017 Symphony Communication Services, LLC.
 *
 * Licensed to The Symphony Software Foundation (SSF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The SSF licenses this file
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

package org.symphonyoss.s2.japigen;

public class JAPIGEN
{
  /* General Constants */
  public static final String TEMPLATE            = "template";
  public static final String PROFORMA            = "proforma";

  /* JSON Constants */
  public static final String X_MODEL             = "x-japigen-model";
  public static final String X_ID                = "x-japigen-id";
  public static final String X_ATTRIBUTES        = "x-japigen-attributes";
  public static final String X_CARDINALITY       = "x-japigen-cardinality";
  public static final String X_CARDINALITY_LIST  = "LIST";
  public static final String X_CARDINALITY_SET   = "SET";
  public static final String DISCRIMINATOR       = "discriminator";
  public static final String PROPERTY_NAME       = "propertyName";
  public static final String MAPPING             = "mapping";
  public static final String ENUM                = "enum";

  /* Root property names in the template data model */

  public static final String MODEL               = "model";

  public static final String JAVA_GEN_PACKAGE    = "javaGenPackage";
  public static final String JAVA_FACADE_PACKAGE = "javaFacadePackage";

  public static final String YEAR                = "year";
  public static final String YEAR_MONTH          = "yearMonth";
  public static final String DATE                = "date";

  public static final String IS_FACADE           = "isFacade";
  public static final String TEMPLATE_NAME       = "templateName";
  public static final String TEMPLATE_DEBUG      = "templateDebug";
  public static final String PATHS               = "paths";
  public static final String METHOD_GET          = "get";
  public static final String METHOD_POST         = "post";
  public static final String METHOD_PUT          = "put";
  public static final String METHOD_DELETE       = "delete";
  public static final String METHOD_OPTIONS      = "options";
  public static final String METHOD_HEAD         = "head";
  public static final String METHOD_PATCH        = "patch";
  public static final String METHOD_TRACE        = "trace";
}
