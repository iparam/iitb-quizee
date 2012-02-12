module FolderHelper
  
  def folders_structure
      Jbuilder.encode do |json|
        json.array!(@folders) do |json,folder|
          json.attr do |json|
            json.id dom_id(folder)
          end
          json.data do |json|
            json.title folder.name
            json.attr do |json|
              json.id folder.name
              json.href "#"
              json.class "clicked"
              json.data_id folder.id
            end
          end  
          json.children(folder.children) do|json,folder| 
            extract_children(json,folder)
          end   
          json.state "closed"
        end
      end
   
  end
  
  
  def extract_children(json,folder)
     json.attr do |json|
       json.id dom_id(folder)
     end
     json.data do |json|
       json.title folder.name
       json.attr do |json|
          json.id folder.name
          json.href "#"
          json.class "clicked"
          json.data_id folder.id
       end
     end  
     json.children(folder.children) do|json,folder| 
       extract_children(json,folder)
     end   
      json.state "closed"     
  end  

  def folder_data(folder)
    Jbuilder.encode do |json|
      extract_children(json,folder)
    end  
  end

  def parent_id(folder)
    if folder.parent.nil?
      return "fileTree"
    else
      return dom_id(folder.parent)
    end  
  end
#[
#  {
#    "attr"  =>  { "id"  => "root" },
#    "data"  =>  {
#      "title"  => "Root",
#      "attr" =>  { "id"  =>  "root","href"  =>  "#" ,"class"  => "jstree-clicked" }
#    },
#    "children" => [],
#    "state" => "closed"
#  },
#  {
#    "attr"  =>  { "id"  => "node-1" },
#    "data"  =>  {
#      "title"  => "Node-1",
#      "attr" =>  { "id"  =>  "node-1","href"  =>  "#" ,"class"  => "jstree-clicked" }
#    },
#    "children" => [],
#    "state" => "closed"
#  }            
#] 
          
end
