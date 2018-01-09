<#include "../S2-japigen-template-java-Prologue.ftl">
<@setPrologueJavaType model/>
import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import com.symphony.s2.japigen.runtime.exception.NoSuchRecordException;
import com.symphony.s2.japigen.runtime.exception.PermissionDeniedException;
import com.symphony.s2.japigen.runtime.exception.ServerErrorException;
import com.symphony.s2.japigen.runtime.IModelHandler;

<@importFieldTypes model true/>

<#include "Path.ftl">
public interface I${modelJavaClassName}ModelHandler extends IModelHandler
{
<#list model.operations as operation>
  <@setJavaMethod operation/>
  ${methodReturnType} handle${operation.camelCapitalizedName}(
	<#list operation.parameters as name, parameter>
	  <@setJavaType parameter.schema/>
	  <#if parameter.isRequired>
    @Nonnull  ${javaClassName?right_pad(25)} ${parameter.camelName}<#sep>,
    <#else>
    @Nullable ${javaClassName?right_pad(25)} ${parameter.camelName}<#sep>,
    </#if>
	</#list>
	
    ) ${methodThrows};
    
</#list>
}
<#include "../S2-japigen-template-java-Epilogue.ftl">