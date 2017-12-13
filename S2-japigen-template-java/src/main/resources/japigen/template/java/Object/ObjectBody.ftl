
  @Override
  public ImmutableJsonObject getJsonObject()
  {
    return jsonObject_;
  }
    
  @Override
  public String toString()
  {
    return asString_;
  }

  @Override
  public String serialize()
  {
    return asString_;
  }

  @Override
  public int hashCode()
  {
    return asString_.hashCode();
  }

  @Override
  public boolean equals(Object obj)
  {
    if(obj instanceof ${modelJavaClassName}ModelObject)
      return asString_.equals(((${modelJavaClassName}ModelObject)obj).asString_);
    
    return false;
  }
