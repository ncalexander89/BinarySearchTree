require 'pry-byebug'

require_relative 'node'

class Tree
    attr_accessor :root

    def initialize (array)
        @array = array.sort.uniq
        @root = build_tree (@array)
    end

    def build_tree (array)
        return nil if array.empty?
        mid = (array.length-1)/2
        root = Node.new(array[mid])
        # binding.pry  
        root.left = build_tree(array[0...mid])
        root.right = build_tree(array[mid+1..-1])
        root
    end

    def insert (key, node=@root)
        return Node.new(key) if node.nil?
        return node if node.data == key

        if node.data < key
            node.right = insert(key, node.right)
        else
            node.left = insert(key, node.left)
        end
        node
    end

    def delete (root, key)
        return root if root.nil?
        if key < root.data
            root.left = delete(root.left, key)
        elsif key > root.data
            root.right = delete(root.right, key)
        else
        return root.left if root.right.nil?
        return root.right if root.left.nil?
        root.data = minValueNode(root.right).data
        #recursuvily finds the next biggest node and returns nil (removes)
        root.right = delete(root.right, root.data)
        end
        root
    end

    def minValueNode(node)
        current = node
        until current.left.nil?
            current = current.left
        end
        current
    end

    def pretty_print(node = @root, prefix = '', is_left = true)
        pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
        puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
        pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
    end

    def find (node, value)
        return nil if node.nil?
        return node if node.data == value
        if value < node.data
            find(node.left, value)
        elsif value > node.data
            find(node.right, value)
        end
    end

    def level_order (&block)
        queue = [root]
        result = []
        until queue.empty?
            node=queue.shift
            if block_given? 
                yield node
            else 
                result << node.data
            end
            queue << node.left if node.left
            queue << node.right if node.right
        end
        return result unless block_given?
    end 

    def preorder(&block)
        queue = [root]
        result = []
        until queue.empty?
            node = queue.pop
            if block_given? 
                yield node
            else 
                result << node.data
            end
            queue << (node.right) if node.right
            queue << (node.left) if node.left
        end
        return result unless block_given?
    end

    def inorder (&block)
        queue=[]
        result=[]
        current=root
        until current.nil? && queue.empty?
            unless current.nil?
                queue << current
                current = current.left
            else
                current = queue.pop
                if block_given? 
                    yield current
                else
                result << current.data
                end
                current = current.right
            end
        end
        return result unless block_given?
    end

    def postorder(&block)
        queue=[]
        result=[]
        current=root
        last_visited=nil
        until queue.empty? && current.nil?
            unless current.nil?
                queue << current
                current = current.left
            else
                peek = queue.last
                if peek.right && peek.right != last_visited
                    current = peek.right
                else
                    node = queue.pop
                    if block_given?
                        yield node
                    else
                        result << node.data
                    end
                end
                last_visited = node
            end
        end
        return result unless block_given?
    end

    def height(node=root)
        return -1 if node.nil?
        left_height = height(node.left)
        right_height = height(node.right)
        [left_height, right_height].max + 1
    end

    def depth(node)
        return -1 if node.nil?
        count = 0
        current = @root
        while current != node
            count += 1
            if node.data < current.data
              current = current.left
            elsif node.data > current.data
              current = current.right
            end
        end
        count
    end

    def balanced?(node = @root)
        return true if node.nil?
    
        left_height = height(node.left)
        right_height = height(node.right)
    
        (left_height - right_height).abs <= 1 &&
          balanced?(node.left) &&
          balanced?(node.right)
      end

    def rebalance
        elements = inorder
        @root = build_tree(elements)
    end
  
    def inorder(node = @root, result = nil)
        result ||= []  # Initialize result as an empty array if it's not provided

        return result if node.nil?

        inorder(node.left, result)
        result << node.data
        inorder(node.right, result)

        result
    end
  
end

random_numbers = Array.new(15) { rand(1..100) }

bst = Tree.new(random_numbers)
# bst.delete(bst.root, 67)
# bst.find(bst.root, 6345)
# d = bst.find(bst.root, 324)

# bst.level_order { |node| puts "yo dawg #{node.data}"}
# bst.postorder
# bst.height
# bst.depth(bst.root)
# bst.depth(d)
# p bst.depth(d)
bst.pretty_print(bst.root)

puts bst.balanced? ? 'Your Binary Search Tree is balanced.' : 'Your Binary Search Tree is not balanced.'

puts 'Level order traversal: '
puts bst.level_order

puts 'Preorder traversal: '
puts bst.preorder

puts 'Inorder traversal: '
puts bst.inorder

puts 'Postorder traversal: '
puts bst.postorder

10.times do
    a = rand(100..150)
    bst.insert(a)
    puts "Inserted #{a} to tree."
  end

puts bst.balanced? ? 'Your Binary Search Tree is balanced.' : 'Your Binary Search Tree is not balanced.'

bst.pretty_print(bst.root)

bst.rebalance

puts bst.balanced? ? 'Your Binary Search Tree is balanced.' : 'Your Binary Search Tree is not balanced.'

puts 'Level order traversal: '
puts bst.level_order

puts 'Preorder traversal: '
puts bst.preorder

puts 'Inorder traversal: '
puts bst.inorder

puts 'Postorder traversal: '
puts bst.postorder

bst.pretty_print(bst.root)
