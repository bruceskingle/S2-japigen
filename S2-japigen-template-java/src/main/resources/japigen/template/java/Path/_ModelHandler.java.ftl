<#include "../S2-japigen-template-java-Prologue.ftl">
<@setPrologueJavaType model/>
import javax.annotation.concurrent.Immutable;

import com.symphony.s2.japigen.runtime.ModelHandler;
import com.symphony.s2.japigen.runtime.http.ParameterLocation;
import com.symphony.s2.japigen.runtime.http.RequestContext;

/*
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
*/

<@importFieldTypes model true/>

import ${javaFacadePackage}.I${model.model.camelCapitalizedName};
import ${javaFacadePackage}.I${modelJavaClassName}Handler;

<#include "Path.ftl">
@Immutable
public abstract class ${modelJavaClassName}ModelHandler extends ModelHandler implements I${modelJavaClassName}Handler
{

}
<#include "../S2-japigen-template-java-Epilogue.ftl">