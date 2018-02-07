<#include "../S2-japigen-template-java-Prologue.ftl">
<#assign model=model.type>
<@setPrologueJavaType model/>

import com.symphony.s2.japigen.runtime.IModelObject;

<@importFieldTypes model true/>

<#include "Object.ftl">
public interface I${model.camelCapitalizedName}ModelObject extends IModelObject
{
<#list model.fields as field>
  <@setJavaType field/>
  
  ${fieldType} get${field.camelCapitalizedName}();
</#list>
}
<#include "../S2-japigen-template-java-Epilogue.ftl">