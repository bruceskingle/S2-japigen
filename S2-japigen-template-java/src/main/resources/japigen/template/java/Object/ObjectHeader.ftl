<#include "../S2-japigen-template-java-Prologue.ftl">
<@setPrologueJavaType model/>
import javax.annotation.concurrent.Immutable;

import com.google.protobuf.ByteString;

import com.symphony.s2.japigen.runtime.IModelObject;
import com.symphony.s2.japigen.runtime.JapigenRuntime;
import com.symphony.s2.japigen.runtime.ModelObject;
import com.symphony.s2.japigen.runtime.ModelObjectFactory;

import org.symphonyoss.s2.common.dom.IBooleanProvider;
import org.symphonyoss.s2.common.dom.IStringProvider;
import org.symphonyoss.s2.common.dom.IIntegerProvider;
import org.symphonyoss.s2.common.dom.ILongProvider;
import org.symphonyoss.s2.common.dom.IFloatProvider;
import org.symphonyoss.s2.common.dom.IDoubleProvider;
import org.symphonyoss.s2.common.dom.IByteStringProvider;
import org.symphonyoss.s2.common.dom.json.IJsonDomNode;
import org.symphonyoss.s2.common.dom.json.IImmutableJsonDomNode;
import org.symphonyoss.s2.common.dom.json.ImmutableJsonObject;
import org.symphonyoss.s2.common.dom.json.JsonArray;
import org.symphonyoss.s2.common.dom.json.MutableJsonObject;

import org.symphonyoss.s2.common.exception.BadFormatException;

<@importFieldTypes model true/>

import ${javaFacadePackage}.${model.model.camelCapitalizedName}Factory;
import ${javaFacadePackage}.${modelJavaClassName};

<#include "Object.ftl">
@Immutable
public abstract class ${modelJavaClassName}ModelObject extends ModelObject implements I${modelJavaClassName}ModelObject
{
  public static final String TYPE_ID = "${model.model.japigenId}#/components/schemas/${model.name}";

<@generateEnums "  " model/>
  private final ${(modelJavaClassName + ".Factory")?right_pad(25)} _factory_;
  private final ${"ImmutableJsonObject"?right_pad(25)}  jsonObject_;
  private final ${"String"?right_pad(25)}  asString_;
