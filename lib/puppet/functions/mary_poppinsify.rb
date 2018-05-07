Puppet::Functions.create_function(:'mary_poppinsify') do
    dispatch :poppinsify do
        required_repeated_param 'Array[String]', :things
    end

    def poppinsify(*things)
        things.join(', ') << ". These are a few of my favourite things.\n"
    end
end
