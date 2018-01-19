<#include "../S2-japigen-template-java-Prologue.ftl">
<@setPrologueJavaType model/>
import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import com.symphony.s2.japigen.runtime.exception.JapiException;
import com.symphony.s2.japigen.runtime.IModelHandler;

<@importFieldTypes model true/>

<#include "Path.ftl">
public interface I${modelJavaClassName}PathHandler extends I${model.model.camelCapitalizedName}ModelHandler
{
<#list model.operations as operation>
  <@printMethodJavadoc operation/>
  ${methodResponseDecl} handle${operation.camelCapitalizedName}(
  <#if operation.payload??>
  <@setJavaType operation.payload.schema/>
  <#if operation.payload.isRequired>
    @Nonnull  ${javaClassName?right_pad(25)} _payload<#if operation.parameters?size != 0>,</#if>
  <#else>
    @Nullable ${javaClassName?right_pad(25)} _payload<#if operation.parameters?size != 0>,</#if>
  </#if>
  </#if>
	<#list operation.parameters as parameter>
	  <@setJavaType parameter.schema/>
	  <#if parameter.isRequired>
    @Nonnull  ${javaClassName?right_pad(25)} ${parameter.camelName}<#sep>,
    <#else>
    @Nullable ${javaClassName?right_pad(25)} ${parameter.camelName}<#sep>,
    </#if>
	</#list>
	
    ) throws JapiException;
    
</#list>
}
<#include "../S2-japigen-template-java-Epilogue.ftl">