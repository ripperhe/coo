module Coo
  module Helper
    module RegexpCollection

      # @return [0个或多个 number alphabet undlerline hyphen]
      def self.n_a_u_h_0_n
        return /^[A-Za-z0-9_-]*$/
      end

      def self.n_a_u_h_1_n
        return /^[A-Za-z0-9_-]+$/
      end

      def self.n_a_u_h_p_0_n
        return /^([A-Za-z0-9_-]|\.)*$/
      end

      # @return [单个 number alphabet]
      def self.n_a_1
        return /^[0-9A-Za-z]$/
      end

      def valid_str?(str, valid_regexp)
        return true if (valid_regexp.match(str))
        false
      end

    end
  end
end