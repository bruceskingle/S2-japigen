<#include "../S2-japigen-template-java-Prologue.ftl">
<@setPrologueJavaType model/>
import javax.annotation.concurrent.Immutable;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.symphony.s2.japigen.runtime.ModelServlet;
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


@Immutable
public abstract class ${modelJavaClassName}ModelServlet extends ModelServlet
{
  private static final long serialVersionUID = 1L;
<#--   
  private final I${modelJavaClassName}Handler handler_;
  
  public ${modelJavaClassName}ModelServlet(I${modelJavaClassName}Handler handler)
  {
    handler_ = handler;
  }
  
  @Override
  public String getUrlPath()
  {
    return "${model.bindPath}";
  }
 <#list model.operations as operation>
 
 	@Override
 	protected final void do${operation.camelCapitalizedName}(HttpServletRequest req, HttpServletResponse resp) throws ServletException
	{
	   ${"RequestContext"?right_pad(25)} context = new RequestContext(req, resp);

	<#list operation.parameters as name, parameter>
	// parameter.class = ${parameter.class}
	// parameter.name = ${parameter.name}
  // parameter.location = ${parameter.location}
  // parameter.schema.class = ${parameter.schema.class}
		<@setJavaType parameter.schema/>
		<@printField/>
		${javaFieldClassName?right_pad(25)} _${parameter.camelName}Value = context.getParameterAs${javaFieldClassName}("${parameter.name}", ParameterLocation.${parameter.location}, ${parameter.isRequired?c});
		${javaClassName?right_pad(25)} ${parameter.camelName} = _${parameter.camelName}Value == null ? null :
		${" "?right_pad(25)}	     ${javaConstructTypePrefix}_${parameter.camelName}Value${javaConstructTypePostfix};

		<#if requiresChecks>
		<@checkLimits "    " parameter parameter.camelName/>
		</#if>
	</#list>
	   if(context.preConditionsAreMet())
	   {
	     handle${operation.camelCapitalizedName}(
	<#list operation.parameters as name, parameter>
		    ${parameter.camelName}<#sep>,
	</#list>
	
		  );
		}
	}
 </#list>
 <#list model.unsupportedOperations as operation>
 
 	@Override
 	protected final void do${operation}(HttpServletRequest req, HttpServletResponse resp) throws IOException
	{
		unsupportedOperation(req, resp, "${operation}");
	}
 </#list>
 -->
}
<#include "../S2-japigen-template-java-Epilogue.ftl">