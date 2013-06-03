Fixjour do
  define_builder(User) do |klass, overrides|
    k = klass.new({
    :email=>"users#{rand}@blah.com",
    :password=> 'xxxxxx', # test
    :password_confirmation=> 'xxxxxx' # test
    })
    k
  end
  
  
  define_builder(Person) do |klass, overrides|
    klass.new({
      :email => "person#{rand}@test.com"
    })
  end
  
  define_builder(Project) do |klass, overrides|
    klass.new({
      :name => "project #{rand}"
    })
  end
  
  define_builder(ProjectMembership) do |klass, overrides|
    klass.new({    })
  end
  
  
  
end






include Fixjour


def team_create
  @owner = create_user.person
  @project = @owner.reload.projects.first
  @member = @project.invite_member(:email => "member@test.com", :invited_by => @owner, :first_name => "steve").person
end


