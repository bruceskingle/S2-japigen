<#include "../S2-japigen-template-java-Prologue.ftl">
import javax.annotation.concurrent.Immutable;

import org.symphonyoss.s2.common.dom.IStringProvider;
import org.symphonyoss.s2.common.dom.json.IImmutableJsonDomNode;
import org.symphonyoss.s2.common.dom.json.ImmutableJsonObject;
import org.symphonyoss.s2.common.exception.BadFormatException;

import com.symphony.s2.japigen.runtime.JapigenRuntime;
import com.symphony.s2.japigen.runtime.ModelObject;
import com.symphony.s2.japigen.runtime.ModelSchemas;


<#--- if templateDebug?? --->
<#-- Print all Schemas -->
/* =====================================================================================================
 * Schema ${model}
 * ===================================================================================================*/
<#list model.children as object>
<@setModelJavaType object/>
<@printModel/>
<#switch object.elementType>
  <#case "Object">
    <#list object.fields as field>
<@setJavaType field/>
      <@printField/>
    </#list>
    <#break>
</#switch>




 </#list>
 <#--- /#if -->

<#list model.children as object>
// object.camelCapitalizedName ${object.camelCapitalizedName};
// object.elementType ${object.elementType}
<#switch object.elementType>
    <#case "Object">
    <#case "AllOf">
import ${javaFacadePackage}.${object.camelCapitalizedName};
      <#break>
    
    <#case "OneOf">
// ${object.elementType} needs to be added
      <#break>
  </#switch>
</#list>
import ${javaFacadePackage}.${model.camelCapitalizedName}Schemas;

public abstract class ${model.camelCapitalizedName}ModelSchemas extends ModelSchemas implements I${model.camelCapitalizedName}ModelSchemas
{
  @Override
  public ModelObject create(ImmutableJsonObject jsonObject) throws BadFormatException
  {
    String typeId = jsonObject.getString(JapigenRuntime.JSON_TYPE);
    
    switch(typeId)
    {
// model ${model.camelCapitalizedName}
// model.model ${model.model.camelCapitalizedName}

<#list model.children as object>
  <#switch object.elementType>
    <#case "Object">
    <#case "AllOf">
      case ${object.camelCapitalizedName}.TYPE_ID:
        return new ${object.camelCapitalizedName}(jsonObject);

      <#break>
    
    <#case "OneOf">
// ${object.elementType} needs to be added
      <#break>
  </#switch>
</#list>
      default:
        throw new BadFormatException("Unknown type \"" + typeId + "\"");
        
    }
  }
}
<#include "../S2-japigen-template-java-Epilogue.ftl">