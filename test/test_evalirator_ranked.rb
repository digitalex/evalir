require 'test/unit'
require 'evalir'

class EvaliratorRankedTest < Test::Unit::TestCase
  def setup
    relevant = [3, 5, 9, 25, 39, 44, 56, 71, 89, 123]
    retrieved = [123,84,56,6,8,9,511,129,187,25,38,48,250,113,3]
    @e = Evalir::Evalirator.new(relevant, retrieved)
  end

  def test_top_10_percent
    assert_equal([123, 84], @e.top_percent(10))
  end
  
  def test_precision_at_rank_6
    assert_equal(0.5, @e.precision_at_rank(6))
  end
  
  def test_precision_at_recall_0_1
    assert_equal(0.5, @e.precision_at_recall(0.1))
  end
  
  def test_precision_at_recall_0
    assert_equal(1.0, @e.precision_at_recall(0.0))
  end
  
  def test_precision_recall_curve
    relevant = [1,3,5,7,9]
    retrieved = [1,2,3,4,5,6,7,8,9,10]
    expected = [1.0,1/1.0,1/2.0,2/3.0,2/4.0,3/5.0,3/6.0,4/7.0,4/8.0,5/9.0,5/10.0]
    evalirator = Evalir::Evalirator.new(relevant, retrieved)
    assert_equal(expected, evalirator.precision_recall_curve)
  end
  
  def test_r_precision
    assert_equal(0.4, @e.r_precision)
  end
  
  def test_rank
    assert_equal(1.0, @e.rank)
  end
  
  def test_reciprocal_rank
    assert_equal(1.0, @e.reciprocal_rank)
  end
  
  def test_average_precision
    e1 = Evalir::Evalirator.new([1,3,4,5,6,10], [1,2,3,4,5,6,7,8,9,10])
    assert_equal(0.78, e1.average_precision.round(2))
    
    e2 = Evalir::Evalirator.new([2,5,6,7,9,10], [1,2,3,4,5,6,7,8,9,10])
    assert_equal(0.52, e2.average_precision.round(2))
  end
  
  def test_dcg_at_5
    expected = 1.0 + (1.0/Math.log(3,2))
    assert_equal(expected, @e.dcg_at(5))
  end

  def test_ndcg_at_3
    dcg = 1.0 + (1.0/Math.log(3,2))
    idcg = 2.0 + (1.0/Math.log(3,2))
    assert_equal(dcg/idcg, @e.ndcg_at(3))
  end
  
  def test_dcg_when_no_relevant
    e = Evalir::Evalirator.new([1,2,3],[4,5,6])
    assert_equal(0.0, e.dcg_at(3))
  end
    
  def test_ndcg_when_no_relevant
    e = Evalir::Evalirator.new([1,2,3], [4,5,6])
    assert_equal(0.0, e.ndcg_at(3))
  end
end

